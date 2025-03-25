import { history } from '@cc_interview/basic';
import { QuestionListComp } from '@cc_interview/home/src/main/ets/components/QuestionListComp';
import { router } from '@kit.ArkUI'
import { SearchHistory } from '../views/history/SearchHistory';

@Entry
@Component
struct SearchPage {
  @StorageProp('topHeight') topHeight: number = 0
  @State keyword: string = ''
  @State isSearch: boolean = false

  build() {
    Column() {
      Row({ space: 16 }) {
        Search({ placeholder: '请输入试题关键字', value: this.keyword })
          .placeholderFont({ size: 14 })
          .height(32)
          .layoutWeight(1)
          .defaultFocus(true)
          .onSubmit((value) => {
            this.keyword = value
            if (this.keyword) {
              this.isSearch = true
              history.setItem(value)
            }
          })
          .onChange(value => {
            this.keyword = value
            if (!value) {
              this.isSearch = false
            }
          })
        Text('取消')
          .fontColor($r('app.color.black'))
          .fontSize(15)
          .fontWeight(500)
          .onClick(() => router.back())
      }
      .height(64)
      .padding({ left: 16, right: 16 })
      .border({ width: { bottom: 0.5 }, color: $r('app.color.common_gray_border') })

      Column() {
        if (this.isSearch) {
          // 试题列表
          QuestionListComp({
            keyword: this.keyword
          })
        } else {
          SearchHistory({
            onSearch: keyword => {
              this.keyword = keyword
              this.isSearch = true
            }
          })
        }
      }
      .layoutWeight(1)
    }
    .padding({ top: this.topHeight })
    .width('100%')
    .height('100%')
  }
}