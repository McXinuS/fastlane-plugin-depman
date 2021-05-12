describe Fastlane::Actions::DepmanAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The depman plugin is working!")

      Fastlane::Actions::DepmanAction.run(nil)
    end
  end
end
