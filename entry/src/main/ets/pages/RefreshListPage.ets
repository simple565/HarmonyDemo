import { UiConstants } from '../constants/UiConstants'
import { RefreshList } from '../views/RefreshList'

@Entry
@Component
struct RefreshListPage {
  @State curPage: number = 0
  @State list: string[] = []
  maxPage: number = 2

  build() {
    Row() {
      RefreshList({
        doRefresh: async () => {
          return this.reloadData()
        },
        doLoadMore: async () => {
          return this.loadMoreData()
        }
      }) {
        ForEach(this.list, (item: string) => {
          ListItem() {
            Row() {
              Text(item)
                .layoutWeight(1)
                .backgroundColor(Color.Yellow)
            }
            .height(UiConstants.PRESENT_12)
            .backgroundColor(Color.Red)
            .borderRadius(10)
            .margin(10)
          }
        })
      }
    }
  }

  private loadData(): Promise<string[]> {
    console.log(`load data page ${this.curPage}`)
    return new Promise<string[]>((resolve) => {
      if (this.curPage > this.maxPage) {
        resolve([])
      }
      let result: string[] = []
      for (let index = 0; index < 10; index++) {
        result.push(`index ${index + this.curPage * 10} ${Date.now()}`)
      }
      console.log(`load result count ${result.length}`)
      setTimeout(() => {
        resolve(result)
      }, 3000)
    })
  }

  private reloadData(): Promise<boolean> {
    this.curPage = 0
    return this.loadData().then((res) => {
      this.list = res
      console.log(`reload data then ${res.length}`)
      return res.length != 0
    })
  }

  private loadMoreData(): Promise<boolean> {
    this.curPage += 1
    return this.loadData().then((res) => {
      this.list.push(...res)
      console.log(`load more data then ${res.length}`)
      return res.length != 0
    })
  }
}