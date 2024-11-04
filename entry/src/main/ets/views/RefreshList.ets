import { SwipeRefresher } from '@kit.ArkUI'
import { UiConstants } from '../constants/UiConstants'

@Component
export struct RefreshList {
  doRefresh: () => Promise<boolean> = () => {
    return new Promise<boolean>(() => {
    })
  }
  doLoadMore: () => Promise<boolean> = () => {
    return new Promise<boolean>(() => {
    })
  }
  @BuilderParam
  listContent: () => void = this.defaultListContentBuilder
  // 下拉刷新状态
  @State refreshing: boolean = false
  // 上拉刷新状态
  @State loading: boolean = false
  @State finished: boolean = false

  async onRefresh() {
    console.log(`onRefresh start`)
    if (this.loading) {
      // 正在加载更多不进行刷新
      return
    }
    this.refreshing = true
    this.finished = false
    const result = await this.doRefresh()
    console.log(`onRefresh result ${result}`)
    this.refreshing = false
    this.finished = true
    console.log(`onRefresh end`)
  }

  async onLoadMore() {
    console.log(`onLoadMore start`)
    if (this.loading || this.refreshing) {
      return
    }
    this.loading = true
    this.finished = false
    const result = await this.doLoadMore()
    console.log(`onLoadMore result ${result}`)
    this.loading = false
    this.finished = true
    console.log(`onLoadMore end`)
  }

  build() {
    Refresh({ refreshing: this.refreshing }) {
      List() {
        this.listContent()
        this.listFooterBuilder()
      }
      .width(UiConstants.PRESENT_100)
      .height(UiConstants.PRESENT_100)
      .onReachEnd(() => {
        this.onLoadMore()
      })
      .scrollBar(BarState.Off)
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      })
      .edgeEffect(EdgeEffect.None)
    }
    .onRefreshing(() => {
      this.onRefresh()
    })
  }

  @Builder
  defaultListContentBuilder() {
    ListItem() {
      Row() {
        Text('数据加载中，请稍候……')
          .backgroundColor(Color.Yellow)
      }.width(UiConstants.PRESENT_100)
      .justifyContent(FlexAlign.Center)
    }.height(UiConstants.PRESENT_10)
  }

  @Builder
  listFooterBuilder() {
    ListItem() {
      if (this.finished) {
        Row() {
          Text('已经到底了')
            .fontColor(Color.Gray)
        }
        .justifyContent(FlexAlign.Center)
      } else if (this.loading) {
        SwipeRefresher({
          content: '努力加载中……',
          isLoading: true
        })
      }
    }.width(UiConstants.PRESENT_100)
    .height(UiConstants.PRESENT_6)
  }
}