require 'rails_helper'

describe GenerateTitleFromFilename do
  subject { described_class }

  it "removes the file extension" do
    expect(subject.call("file.jpg")).to eq("File")
  end

  it "adds spaces for underscores" do
    expect(subject.call("file_file.jpg")).to eq("File File")
    expect(subject.call("file_file_file.jpg")).to eq("File File File")
  end

  it "titleizes the string" do
    expect(subject.call("title.jpg")).to eq("Title")
  end

end
