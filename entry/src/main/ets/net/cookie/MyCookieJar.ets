import { Log } from '../../utils/HiLogUtil';
import Cookie from './Cookie';
import CookieJar from './CookieJar';

export default class MyCookieJar implements CookieJar {
  private static TAG = "MyCookieJar"
  private cache: Cookie[] = []

  saveFromResponse(url: string, cookies: string): void {
    // 对url进行判断，如只有登录的url才需要保存cookie，退出的url需要清空当前cookie
    this.cache = this.string2Cookie(cookies)
    Log.d('saveFromResponse', `parse result ${this.cache.length}`)
    // 持久化操作
  }

  loadForRequest(url: string): string {
    // 对url进行判断，如登录的url不需要传递cookie
    const curTimestamp = Date.now() / 1000
    const validCookies: Cookie[] = []
    this.cache.forEach((cookie) => {
      Log.d('loadForRequest', `current timestamp ${curTimestamp} cookie expire time ${cookie.expiresAt}`)
      if (cookie.expiresAt >= curTimestamp) {
        validCookies.push(cookie)
      }
    })
    if (validCookies.length == 0) {
      return ''
    }
    const result = validCookies.map((cookie) => {
      `${cookie.name}=${cookie.value}`
    }).join('; ')
    Log.d('loadForRequest', result)
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