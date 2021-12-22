import {config1, config2} from './config';

const logger = loggerConstructor('${CRON_IDENTIFIER}');

for (let timezone = 0; timezone < Meteor.settings.tz.length; timezone += 1) {
  SyncedCron.add({
    name: "\`Describing taste of ${MODEL_TYPE} ${MODEL_NAME_ACTUAL} for strangers.\`",
    timezone: settings.tz,
    schedule(parser) {
      return parser.text('at ${TIME} everyday');
    },
    context: {
      timezone: settings.tz
    },
    job() {
      const currentTimezone = this.timezone;
      const datetime = new Date();
      const allJobs = [];
      logger.info(currentTimezone, datetime, '${IDENTIFIER}', logger, {config1, config2});
    }
  });
}