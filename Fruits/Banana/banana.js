import {config1, config2} from './config';

const logger = loggerConstructor('FRUIT_BANANA_CRON');

for (let timezone = 0; timezone < Meteor.settings.tz.length; timezone += 1) {
  SyncedCron.add({
    name: "\`Describing taste of Fruit Banana for strangers.\`",
    timezone: settings.tz,
    schedule(parser) {
      return parser.text('at 07:00 everyday');
    },
    context: {
      timezone: settings.tz
    },
    job() {
      const currentTimezone = this.timezone;
      const datetime = new Date();
      const allJobs = [];
      logger.info(currentTimezone, datetime, 'BANANA_FRUIT', logger, {config1, config2});
    }
  });
}