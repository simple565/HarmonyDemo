export class Response<T> {
  errorCode: number = 0
  errorMsg: string = ''
  data?: T = undefined
}