import { UiConstants } from '../constants/UiConstants';
import PreferencesUtils from '../utils/PreferencesUtils';

@Entry
@Component
struct PreferencePage {
  keyPreference: string = 'preference'
  @State needSave: string = ''
  @State getSaved: string = ''

  build() {
    Column() {
      TextInput()
        .width(UiConstants.PRESENT_90)
        .height(UiConstants.PRESENT_32)
        .borderRadius(10)
        .backgroundColor($r('sys.color.ohos_id_container_color'))
        .margin(10)
        .onChange((value) => {
          this.needSave = value
        })
      Row() {
        Button('写入')
          .onClick(() => {
            PreferencesUtils.getInstance(getContext()).put(this.keyPreference, `${Date.now()} ${this.needSave}`)
          })
        Button('读取')
          .onClick(() => {
            this.getSaved = PreferencesUtils.getInstance(getContext()).get<string>(this.keyPreference, '')
          })
      }.width(UiConstants.PRESENT_100)
      .justifyContent(FlexAlign.SpaceAround)

      Text(this.getSaved)
        .width(UiConstants.PRESENT_90)
        .height(UiConstants.PRESENT_32)
        .borderRadius(10)
        .backgroundColor($r('sys.color.ohos_id_container_color'))
        .margin(10)
    }
    .height(UiConstants.PRESENT_100)
    .width(UiConstants.PRESENT_100)
    .justifyContent(FlexAlign.Center)
  }
}