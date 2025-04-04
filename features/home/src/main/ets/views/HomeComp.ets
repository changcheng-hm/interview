import { authStore, HcClockIn, HcSearchBox, HdUser, httpInstant, requestClockIn, tracking } from '@cc_interview/basic';
import { HomeCategoryComp } from '../components/HomeCategoryComp';
import { scanBarcode } from '@kit.ScanKit';
import { QuestionDetail } from '../models/QuestionItemModel';
import { promptAction, router } from '@kit.ArkUI';

@Component
export struct HomeComp {
  @StorageProp('topHeight')
  topHeight: number = 0

  @StorageProp('user') user: HdUser = {} as HdUser

  async scanQuestionCode() {
    if (canIUse('SystemCapability.Multimedia.Scan.ScanBarcode')) {
      const result = await scanBarcode.startScanForResult(getContext(this))
      if (result.originalValue) {
        try {
          const item = await httpInstant.request<QuestionDetail>({ url: `question/${result.originalValue}` })
          router.pushUrl({
            url: 'pages/QuestionPage',
            params: {
              item,
              list: [item]
            }
          })
        } catch (e) {
          promptAction.showToast({ message: '没有找到试题' })
        }
      }
    }
  }

  aboutToAppear(): void {
    tracking.report(true)
  }

  build() {
    Column() {
      Row({ space: 16 }) {
        Image($r('app.media.ic_home_scan'))
          .width(24)
          .aspectRatio(1)
          .onClick(() => {
            authStore.checkAuth(() => {
              this.scanQuestionCode()
            })
          })
        // 搜索组件
        HcSearchBox({
          layoutWeightValue: 1,
          onSearchClick: () => {
            router.pushUrl({
              url: 'pages/SearchPage'
            })
          }
        })
        HcClockIn({ clockInCount: this.user.clockinNumbers })
          .onClick(() => {
            requestClockIn()
          })
      }.padding({left: 16, right: 16})
      .height(64)
      .width('100%')

      Swiper() {
        ForEach([$r('app.media.banner_qa'), $r('app.media.banner_pj'), $r('app.media.banner_ai')], (item: ResourceStr, index) => {
          this.swiperItemBuilder(item)
        })
      }.margin({bottom: 16})
      .autoPlay(true)
      .indicator(DotIndicator.dot().bottom(4).selectedItemWidth(20).selectedColor(Color.White))

      Column() {
        HomeCategoryComp()
      }.layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding({
      top: this.topHeight
    })
    .backgroundColor($r('app.color.common_gray_bg'))
  }

  @Builder
  swiperItemBuilder(item: ResourceStr) {
    Row() {
      Image(item)
        .width('100%');
    }.width('100%')
    .padding({ left: 16, right: 16 });
  }
}