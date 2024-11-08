import { Api } from './Api'
import { IRequest } from './IRequest'
import { Response } from './Response'
import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'
import CookieJar from './cookie/CookieJar'
import MyCookieJar from './cookie/MyCookieJar'
import { Log } from '../utils/HiLogUtil'

export class NativeRequest implements IRequest {
  private readonly SUCCESS_CODE = 200
  private readonly TAG: string = 'NativeRequest'
  private baseUrl: string
  private cookieJar: CookieJar

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl
    this.cookieJar = new MyCookieJar()
    Log.d(this.TAG, 'init finish')
  }

  request<T>(api: Api): Promise<Response<T>> {
    const httpRequest = http.createHttp()
    const url = api.getFullUrl(this.baseUrl)
    const options: http.HttpRequestOptions = {
      header: {
        'Content-Type': 'application/json',
        'Cookie': this.cookieJar.loadForRequest(url)
      },
      method: api.method,
      extraData: api.params,
      expectDataType: http.HttpDataType.OBJECT
    }

    return httpRequest.request(url, options).then((response) => {
      if (response.result && response.responseCode === this.SUCCESS_CODE) {
        this.cookieJar.saveFromResponse(url, response.cookies)
        return response.result as Response<T>
      }
      return Promise.reject(response.result)
    }).catch((err: BusinessError) => {
      console.log(`request ${url} error code ${err.code} msg ${err.message}`)
      return Promise.reject(err)
    }).finally(() => {
      httpRequest.destroy()
    })
  }
}