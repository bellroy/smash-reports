require 'spec_helper'

describe Report do
  before :each do
    @db = double("Sequel::Mysql2::Database")
    Report.stub(:report_db_for) { @db }
  end

  context "with a simple SQL query" do
    before { subject.sql_query = "SELECT * FROM foos;" }

    it "should execute the SQL query on the report db" do
      @db.should_receive(:fetch).with("SELECT * FROM foos;")
      subject.execute
    end

    it "should have an empty list of report fields" do
      subject.report_fields.should == []
    end
  end

  context "with an invalid SQL query" do
    before { subject.sql_query = "SELECT * FROM foos WHERE asdf'"}
    it 'should set an error' do
      subject.execute
      subject.results.should be_nil
      subject.error.should_not be_nil
    end
  end


  context "with a SQL query with fields" do
    before { subject.sql_query = "SELECT * FROM foos WHERE bar = '<% bar %>'"}

    it "should execute the SQL query with the given field values" do
      @db.should_receive(:fetch).with("SELECT * FROM foos WHERE bar = 'pants'")
      subject.field_values = { :bar => 'pants' }
      subject.execute
    end

    it "should not execute when no field values are given" do
      @db.should_not_receive :fetch
      subject.field_values = {}
      subject.execute
    end

    it "should list the query's fields" do
      subject.report_fields.should == [:bar]
    end
  end

  it "should accept a blank defaults string" do
    subject.defaults = ""
    subject.valid?
    subject.errors[:defaults].should be_empty
  end

  it "should complain about invalid YAML in defaults" do
    subject.defaults = "foo: {"
    subject.valid?
    subject.errors[:defaults].should_not be_empty
  end

  it "should accept valid YAML in defaults" do
    subject.defaults = "foo: bar\nbaz: pants"
    subject.valid?
    subject.errors[:defaults].should be_empty
  end

  it "should parse YAML defaults for field values" do
    subject.stub(:report_fields) { ['foo', 'baz']}
    subject.defaults = "foo: bar"
    subject.report_fields_with_values[:foo].should == 'bar'
    subject.report_fields_with_values[:baz].should be_empty
  end

  it "should parse date fields" do
    subject.stub(:report_fields) { ['foo_date'] }
    subject.field_values = { 'foo_date' => "1/1/2010" }
    subject.report_fields_with_values[:foo_date].should == "2010-01-01"
  end
end
