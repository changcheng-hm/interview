import { HcClockIn, HcSearchBox } from '@cc_interview/basic';

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
    }
    .width('100%')
    .height('100%')
    .padding({
      top: this.topHeight
    })
    .backgroundColor($r('app.color.common_gray_bg'))
  }
}