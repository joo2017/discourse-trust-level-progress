import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { observes } from "discourse-common/utils/decorators";

export default class UserTrustLevelProgress extends Component {
  @service store;
  @tracked progressData = null;
  @tracked isLoading = true;

  // We observe the user model to reload data if the user changes.
  @observes("args.model")
  modelChanged() {
    this.loadProgressData();
  }

  constructor() {
    super(...arguments);
    this.loadProgressData();
  }



  async loadProgressData() {
    this.isLoading = true;
    if (!this.args.model || !this.args.model.username) {
      this.isLoading = false;
      return;
    }

    try {
      const username = this.args.model.username;
      const data = await ajax(`/trust-level-progress/${username}`);
      this.progressData = data;
    } catch (error) {
      console.error("Failed to load trust level progress data", error);
    } finally {
      this.isLoading = false;
    }
  }
}
