import hilog from '@ohos.hilog';

const FLAG = 0x0002
const TAG = 'interview_default_tag'

export enum LogLevel {
  DEBUG = 3,
  INFO = 4,
  WARN = 5,
  ERROR = 6,
  FATAL = 7
}

class Logger {

  private formatArgs(args: string[]) {
    let format = ''
    for (let i = 0; i < args.length; i ++) {
      format += '%{public}s'
      if(i != args.length - 1) {
        format += ', '
      }
    }
    return format
  }

  debug(...args: string[]) {
    hilog.debug(FLAG, TAG, this.formatArgs(args), args)
  }

  info(...args: string[]) {
    hilog.info(FLAG, TAG, this.formatArgs(args), args)
  }

  warn(...args: string[]) {
    hilog.warn(FLAG, TAG, this.formatArgs(args), args)
  }

  error(...args: string[]) {
    hilog.error(FLAG, TAG, this.formatArgs(args), args)
  }

  fatal(...args: string[]) {
    hilog.fatal(FLAG, TAG, this.formatArgs(args), args)
  }

  isLoggable(level: hilog.LogLevel) {
    hilog.isLoggable(FLAG, TAG, level)
  }
}

export const logger = new Logger()