import { HcClockIn, HcSearchBox } from '@cc_interview/basic';
import { HomeCategoryComp } from '../components/HomeCategoryComp';

@Component
export struct HomeComp {
  @StorageProp('topHeight')
  topHeight: number = 0

  build() {
    Column() {
      Row({ space: 16 }) {
        Image($r('app.media.ic_home_scan'))
          .width(24)
          .aspectRatio(1)
        // 搜索组件
        HcSearchBox({
          layoutWeightValue: 1
        })
        HcClockIn({
          clockInCount: 2
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