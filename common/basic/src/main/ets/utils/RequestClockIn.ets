import { promptAction, router } from '@kit.ArkUI'
import { authStore } from './auth';
import { httpInstant } from './Http';

interface ClockRes {
  clockinNumbers: number
}

export const requestClockIn = async () => {
  const user = authStore.getUser()
  if (user.token) {
    if (user.clockinNumbers === 0) {
      const res = await httpInstant.request<ClockRes>({ url: 'clockin', method: 'post' })
      user.clockinNumbers = res.clockinNumbers
      authStore.setUser(user)
      promptAction.showToast({ message: '打卡成功' })
    }
    router.pushUrl({ url: 'pages/ClockInPage' })
  } else {
    router.pushUrl({ url: 'pages/LoginPage' })
  }
}