import { authStore, themeUtils } from '@cc_interview/basic';
import { BootView } from '../views/boot/BootView';

@Entry
@Component
struct BootPage {

  aboutToAppear(): void {
    // 获取系统当前主题配置并设置应用主题
    themeUtils.initThemeSetting()
    // 当前页面开启全屏
    themeUtils.enableFullScreen()
    // 初始化用户鉴权信息
    authStore.initUser()
  }

  build() {
    Column() {
      BootView()
    }
  }
}