import { Api } from './Api'
import { IRequest } from './IRequest'
import { Response } from './Response'
import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'

export class NativeRequest implements IRequest {
  baseUrl: string

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl
  }

  request<T>(api: Api): Promise<Response<T>> {
    const instance = http.createHttp()

    const options: http.HttpRequestOptions = {
      header: { 'Content-Type': 'application/json' },
      method: api.method,
      extraData: api.params,
      expectDataType: http.HttpDataType.OBJECT
    }
    let url = api.getFullUrl(this.baseUrl)
    return instance.request(url, options).then((response) => {
      if (response.result) {
        const result = response.result as Response<T>
        if (result.isSuccess()) {
          return result
        }
        if (result.needUserLogin()) {
          return Promise.reject('用户未登录或登录信息已过期')
        }
      }
      return Promise.reject(response.result)
    }).catch((err: BusinessError) => {
      console.log(`request ${url} error code ${err.code} msg ${err.message}`)
      return Promise.reject(err)
    }).finally(() => {
      instance.destroy()
    })
  }
}