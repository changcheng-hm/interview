import { emitter } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { themeUtils } from '@cc_interview/basic';
import { TabBarComp } from '../views/index/TabBarComp';

@Entry
@Component
struct Index {
  @State
  @Watch('onChangeIndex')
  activeIndex: number = 0

  aboutToAppear(): void {
    emitter.on({ eventId: 10000 }, (e) => {
      if (e.data && e.data.activeIndex) {
        this.activeIndex = e.data.activeIndex
      }
    })
  }

  onChangeIndex() {
    if (this.activeIndex === 3) themeUtils.setStatusBarLight()
    else themeUtils.setStatusBarDark()
  }

  onPageShow(): void {
    this.onChangeIndex()
  }

  onPageHide(): void {
    this.onChangeIndex()
    themeUtils.setStatusBarDark()
    this.backTimes = 0
  }

  backTimes: number = 0

  onBackPress(): boolean | void {
    this.backTimes++
    if (this.backTimes <= 1) {
      promptAction.showToast({ message: '再按一次将退出应用' })
    }
    if (this.backTimes >= 2) {
      const ctx = getContext() as common.UIAbilityContext
      ctx.terminateSelf()
    }

    return true
  }

  build() {
    Flex() {
      TabBarComp({ activeIndex: this.activeIndex })
    }
    .backgroundColor($r('app.color.white'))
  }
}