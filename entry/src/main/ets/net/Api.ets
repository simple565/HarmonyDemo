import { http } from '@kit.NetworkKit'

type HttpRequestParams = Record<string, string | number | boolean>

export class Api {
  method: http.RequestMethod
  path: string
  params?: Object

  constructor(method: http.RequestMethod, path: string, params?: Object) {
    this.method = method
    this.path = path
    this.params = params
  }

  getFullUrl(baseUrl: string): string {
    let fullUrl = baseUrl + this.path
    if (this.method === http.RequestMethod.GET && this.params) {
      const paramArray = Object.keys(this.params)
        .map(key => `${key}=${(this.params as HttpRequestParams)[key]}`)
      fullUrl += `?${paramArray.join('&')}`
    }
    console.log(`request full url: ${fullUrl}`)
    return fullUrl
  }
}