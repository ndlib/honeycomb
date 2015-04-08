require 'rails'

RSpec.describe EditorQuery do
  subject {described_class.new(base_relation)}
  let(:base_relation) { User.all }
  let(:modified_relation) { User.all.where(admin: true) }

  describe '#relation' do
    it "filters for users with associated collections" do
      expect(base_relation).to receive(:includes).with(:collections).and_return(base_relation)
      expect(base_relation).to receive(:where).and_return(base_relation)
      expect(base_relation).to receive(:not).with({:collections=>{:id=>nil}}).and_return(base_relation)
      expect(subject.relation).to eq(base_relation)
    end
  end

  describe '#list' do
    it "returns the list sorted by last and first name" do
      expect(subject.relation).to receive(:order).with(:last_name, :first_name).and_call_original
      subject.list
    end
  end

  describe '#find' do
    it "finds the object" do
      expect(subject.relation).to receive(:find).with(1)
      subject.find(1)
    end
  end

  describe '#build' do

    it "builds a object off of the relation and returns the result" do
      expect(subject.relation).to receive(:build).and_return('build')
      expect(subject.build).to eq('build')
    end

    it 'builds a user' do
      expect(subject.build).to be_a_kind_of(User)
    end

    it "accepts default arguments" do
      user = subject.build(username: 'test')
      expect(user.username).to eq('test')
    end
  end

end
