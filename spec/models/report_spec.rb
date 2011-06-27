require 'spec_helper'

describe Report do
  before :each do
    @db = double("Sequel::Mysql2::Database")
    Report.stub(:db) { @db }
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

  context "with a parameterised SQL query" do
    before { subject.sql_query = "SELECT * FROM foos WHERE bar = '<% bar %>'"}

    it "should execute the SQL query with the given parameter values" do
      @db.should_receive(:fetch).with("SELECT * FROM foos WHERE bar = 'pants'")
      subject.execute :bar => 'pants'
    end

    it "should have report fields" do
      subject.report_fields.should == [:bar]
    end
  end
end
