import { promptAction, window } from '@kit.ArkUI';
import { logger } from './logger';
import { ConfigurationConstant } from '@kit.AbilityKit';

class ThemeUtils {

  private windowStage?: window.Window

  initThemeSetting() {
    const app = this.getCustomContext().getApplicationContext()
    app.on('environment', {
      onConfigurationUpdated:(config) => {
        logger.info('===', JSON.stringify(config))
        if(config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
          this.setStatusBarDark()
        } else if(config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
          this.setStatusBarLight()
        }
      },
      onMemoryLevel: (level) => {

      }
    })

    // 获取应用当前主题
    // PersistentStorage.persistProp<ConfigurationConstant.ColorMode>('appColorMode',
    //   ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
    // const appColorMode = AppStorage.get<ConfigurationConstant.ColorMode>('appColorMode')
    // app.setColorMode(appColorMode)
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