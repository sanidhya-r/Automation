import {config1, config2} from './config';

const logger = loggerConstructor('VEGETABLE_ONION_CRON');

for (let timezone = 0; timezone < Meteor.settings.tz.length; timezone += 1) {
  SyncedCron.add({
    name: "\`Describing taste of Vegetable Onion for strangers.\`",
    timezone: settings.tz,
    schedule(parser) {
      return parser.text('at 02:00 everyday');
    },
    context: {
      timezone: settings.tz
    },
    job() {
      const currentTimezone = this.timezone;
      const datetime = new Date();
      const allJobs = [];
      logger.info(currentTimezone, datetime, 'ONION_VEGETABLE', logger, {config1, config2});
    }
  });
}