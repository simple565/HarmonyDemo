import { NativeRequest } from '../net/NativeRequest';
import { IRequest } from '../net/IRequest';
import { UiConstants } from '../constants/UiConstants';
import { router } from '@kit.ArkUI';

export const request: IRequest = new NativeRequest('https://www.wanandroid.com')

@Entry
@Component
struct Index {
  @State curPage: number = 0
  @State demoPagePath: string[] = ['pages/RefreshListPage']
  maxPage: number = 2

  build() {
    List() {
      ForEach(this.demoPagePath, (item: string) => {
        ListItem() {
          Row() {
            Text(item)
              .layoutWeight(1)
          }
          .height(UiConstants.PRESENT_10)
          .backgroundColor($r('sys.color.ohos_id_container_color'))
          .borderRadius(10)
          .margin(10)
          .padding(10)
          .onClick(() => {
            router.pushUrl({ url: item })
          })
        }
      })
    }.width(UiConstants.PRESENT_100)
    .height(UiConstants.PRESENT_100)
  }
}