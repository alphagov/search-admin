RSpec.describe "completion tasks" do
  describe "completion:import_denylist" do
    let(:import_completion_denylist_worker) { instance_double(ImportCompletionDenylistWorker) }

    before do
      allow(ImportCompletionDenylistWorker).to receive(:new).and_return(import_completion_denylist_worker)
      Rake::Task["completion:import_denylist"].reenable
    end

    it "calls the ImportCompletionDenylistWorker" do
      expect(import_completion_denylist_worker)
        .to receive(:perform)

      Rake::Task["completion:import_denylist"].invoke
    end
  end
end
