require 'rails_helper'

describe GenerateTitleFromFilename do
  let(:filename) { "file_name_test.jpg" }
  subject { described_class.new(filename) }
  let(:options) { {} }

  context 'self' do
    subject { described_class }

    describe '#call' do
      describe "default options" do
        it "removes the extension" do
          expect(subject.call("file.jpg")).to eq("file")
        end

        it "does not replace underscores with spaces" do
          expect(subject.call("file_name")).to eq("file_name")
        end

        it "does not titleize the string" do
          expect(subject.call("title")).to eq("title")
        end
      end

      describe 'add_spaces true' do
        let(:options) { {add_spaces: true} }
        it "replaces underscores with spaces" do
          expect(subject.call("file_name", options)).to eq("file name")
        end
      end

      describe 'titleize true' do
        let(:options) { {titleize: true} }
        it "titleizes the string" do
          expect(subject.call("title", options)).to eq("Title")
        end
      end

      describe 'remove_extension false' do
        let(:options) { {remove_extension: false} }
        it "does not remove the file extension" do
          expect(subject.call("file.jpg", options)).to eq("file.jpg")
        end
      end
    end
  end

end
