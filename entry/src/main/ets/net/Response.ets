export class Response<T> {
  errorCode: number = 0
  errorMsg: string = ''
  data?: T = undefined

  isSuccess(): boolean {
    // 可根据服务器返回内容修改判断
    return this.errorCode === 0
  }

  needUserLogin(): boolean {
    // 可根据服务器返回内容修改判断
    return this.errorCode === -1001
  }
}