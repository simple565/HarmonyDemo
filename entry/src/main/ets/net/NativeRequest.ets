import { Api } from './Api'
import { IRequest } from './IRequest'
import { Response } from './Response'
import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit'

export class NativeRequest implements IRequest {
  private readonly SUCCESS_CODE = 0
  baseUrl: string

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl
  }

  request<T>(api: Api): Promise<Response<T>> {
    const httpRequest = http.createHttp()
    const options: http.HttpRequestOptions = {
      header: { 'Content-Type': 'application/json' },
      method: api.method,
      extraData: api.params,
      expectDataType: http.HttpDataType.OBJECT
    }
    let url = api.getFullUrl(this.baseUrl)
    return httpRequest.request(url, options).then((response) => {
      if (response.result && response.responseCode === this.SUCCESS_CODE) {
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