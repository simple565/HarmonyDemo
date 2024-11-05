import { hilog } from '@kit.PerformanceAnalysisKit'

export class Log {
  static d(tag: string = 'HiLogger', message: string) {
    hilog.debug(0xFF00, tag, message)
  }

  static e(tag: string = 'HiLogger', message: string) {
    hilog.error(0xFF00, tag, message)
  }

  static i(tag: string = 'HiLogger', message: string) {
    hilog.info(0xFF00, tag, message)
  }
}
