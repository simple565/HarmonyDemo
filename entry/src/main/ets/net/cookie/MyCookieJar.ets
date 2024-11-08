import { Log } from '../../utils/HiLogUtil';
import Cookie from './Cookie';
import CookieJar from './CookieJar';
import { preferences } from '@kit.ArkData';

export default class MyCookieJar implements CookieJar {
  private readonly TAG = "MyCookieJar"
  private readonly STORE_NAME = 'MyCookieStore'
  private cache: Cookie[] = []
  private store: preferences.Preferences

  constructor() {
    this.store = preferences.getPreferencesSync(getContext(), {
      name: this.STORE_NAME
    })
    const cacheStr = this.store.getSync(this.TAG, '') as string
    if (cacheStr.length != 0) {
      this.cache = JSON.parse(cacheStr)
    }
    Log.d(this.TAG, `init finish cache size ${this.cache.length}`)
  }

  async saveFromResponse(url: string, cookies: string): Promise<void> {
    // 对url进行判断，如只有登录的url才需要保存cookie，退出的url需要清空当前cookie
    if (!url.includes('/user/login?')) {
      return new Promise<void>(() => {}).then()
    }
    this.cache = this.string2Cookie(cookies)
    Log.d(this.TAG, `saveFromResponse: parse result ${this.cache.length}`)
    // 持久化操作
    this.store.putSync(this.TAG, JSON.stringify(this.cache))
    Log.d(this.TAG, 'saveFromResponse: write cookie to preferences')
    await this.store.flush()
    Log.d(this.TAG, 'saveFromResponse: flush preferences')
  }

  loadForRequest(url: string): string {
    // 对url进行判断，如登录的url不需要传递cookie
    if (url.includes('/user/login?')) {
      return ''
    }
    const curTimestamp = Date.now() / 1000
    Log.d(this.TAG, `loadForRequest: current timestamp ${curTimestamp}`)
    const validCookies: Cookie[] = []
    this.cache.forEach((cookie) => {
      Log.d(this.TAG, `loadForRequest: ${JSON.stringify(cookie)}`)
      if (cookie.expiresAt >= curTimestamp) {
        validCookies.push(cookie)
      }
    })
    if (validCookies.length == 0) {
      return ''
    }
    const result = validCookies.map((cookie) => {
      return `${cookie.name}=${cookie.value}`
    }).join('; ')
    Log.d(this.TAG, `loadForRequest: ${result}`)
    return result
  }

  private string2Cookie(cookieString: string): Cookie[] {
    const cookies: Cookie[] = []
    if (!cookieString) {
      return cookies
    }

    const lines = cookieString.split('\r\n')
    lines.forEach((line) => {
      const attrs = line.split('\t')
      if (attrs.length !== 7 || !attrs[0]) {
        // 分割后的字符串为空或者不足7个字段
        return
      }

      let domain = attrs[0]
      let httpOnly = false
      // #HttpOnly_www.wanandroid.com
      if (domain.startsWith("#HttpOnly_")) {
        domain = domain.substring("#HttpOnly_".length)
        httpOnly = true
      }
      cookies.push({
        domain: domain,
        path: attrs[2],
        expiresAt: parseInt(attrs[4]),
        name: attrs[5],
        value: attrs[6],
        httpOnly: httpOnly,
        persistent: true
      })
    })
    return cookies
  }
}