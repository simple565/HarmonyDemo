import { Api } from '../net/Api';
import { http } from '@kit.NetworkKit';
import { NativeRequest } from '../net/NativeRequest';
import { IRequest } from '../net/IRequest';

export const request: IRequest = new NativeRequest('https://www.wanandroid.com')

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  onPageShow(): void {
    let bannerApi = new Api(http.RequestMethod.GET, '/banner/json')
    request.request<string>(bannerApi).then((res) => {
      console.log(JSON.stringify(res.data))
    })
  }

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}