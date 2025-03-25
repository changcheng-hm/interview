import { promptAction, window } from '@kit.ArkUI';
import { logger } from './logger';
import { common, ConfigurationConstant } from '@kit.AbilityKit';

export const ColorModeKey = 'hc-color-mode'

class ThemeUtils {

  private windowStage?: window.Window

  initThemeSetting() {
    // 持久化颜色主题，默认值亮色模式
    PersistentStorage.persistProp<ConfigurationConstant.ColorMode>(ColorModeKey,
      ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
    // 取出现在应用存储的颜色主题模式
    const colorMode = AppStorage.get<ConfigurationConstant.ColorMode>(ColorModeKey)
    // 设置应用颜色主题模式
    this.setTheme(colorMode!)
  }

  setTheme(mode: ConfigurationConstant.ColorMode) {
    AppStorage.set<ConfigurationConstant.ColorMode>(ColorModeKey, mode)
    const ctx = AppStorage.get<Context>('context')
    ctx?.getApplicationContext().setColorMode(mode)

    const isDark = (ctx as common.UIAbilityContext).config.colorMode == ConfigurationConstant.ColorMode.COLOR_MODE_DARK
    AppStorage.setOrCreate('isDark', isDark)
  }

  // 跟随系统
  notSet() {
    this.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
  }

  // 暗色
  setDark() {
    this.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
  }

  // 亮色
  setLight() {
    this.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
  }

  async getWindowStage() {
    if(this.windowStage) {
      return this.windowStage
    } else {
      return await window.getLastWindow(this.getCustomContext())
    }
  }

  private getCustomContext() : Context {
    const context = AppStorage.get<Context>('context')
    return context!
  }

  enableFullScreen() {
    this.getWindowStage()
      .then((win: window.Window) => {
        win.setWindowLayoutFullScreen(true)
        const topArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
        AppStorage.setOrCreate('topHeight', px2vp(topArea.topRect.height))
        const bottomArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
        AppStorage.setOrCreate('bottomHeight', px2vp(bottomArea.bottomRect.height))
      })
  }

  disableFullScreen() {
    this.getWindowStage()
      .then((win: window.Window) => {
        win.setWindowLayoutFullScreen(false)
        AppStorage.setOrCreate('topHeight', 0)
        AppStorage.setOrCreate('bottomHeight', 0)
      })
  }

  setStatusBarLight() {
    this.setSystemBarStatus({
      statusBarContentColor: '#ffffff'
    })
  }

  setStatusBarDark() {
    this.setSystemBarStatus({
      statusBarContentColor: '#000000'
    })
  }

  private setSystemBarStatus(config: window.SystemBarProperties) {
    this.getWindowStage()
      .then((win: window.Window) => {
        win.setWindowSystemBarProperties(config)
      })
  }
}

export const themeUtils = new ThemeUtils()