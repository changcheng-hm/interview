export { logger } from './src/main/ets/utils/logger'
export { themeUtils, ColorModeKey } from './src/main/ets/utils/themeUtils'
export { authStore, HdUser } from './src/main/ets/utils/auth'
export { BasicConstants } from './src/main/ets/constants/BasicContants'
export { HcClockIn } from './src/main/ets/components/HcClockIn'
export { HcSearchBox } from './src/main/ets/components/HcSearchBox'
export { HcSkeletonItem } from './src/main/ets/components/HcSkeletonItem'
export { HcSkeleton } from './src/main/ets/components/HcSkeleton'
export { httpInstant } from './src/main/ets/utils/Http'
export { HcTag } from './src/main/ets/components/HcTag'
export { HcNavBar } from './src/main/ets/components/HcNavBar'
export { HcLoadingDialog } from './src/main/ets/components/HcLoadingDialog'
export { InputDialog } from './src/main/ets/components/InputDialog'
export { formatTime } from './src/main/ets/utils/TimeUtils'
export { history } from './src/main/ets/utils/History'
export { tracking } from './src/main/ets/utils/Tracking'
export { requestClockIn } from './src/main/ets/utils/RequestClockIn'
export { permission } from './src/main/ets/utils/Permission'
export { audioDB, InterviewAudioItem } from './src/main/ets/utils/AudioDB'

export const LOGIN_EVENT = 'LOGIN_EVENT'

export interface QuestionOptParams {
  id: string
  /* 0 试题  2 面经 */
  type: 0 | 1
  /* 1 点赞  2 收藏 */
  optType: 1 | 2
}

export interface ClockInItem {
  id: string,
  createdAt: string
}

export interface ClockInfo {
  flag: boolean
  clockinNumbers: number
  totalClockinNumber: number
  clockins: ClockInItem[]
}

export interface ClockInfoParams {
  year: string,
  month: string
}

// 学习时间
export interface StudyTimeItem {
  id: string
  name: string
  total: number
  done: number
  undone: number
}

export interface StudyTimeCate {
  type: string,
  list: StudyTimeItem[]
}

export interface StudyTimeData {
  totalTime: number,
  studyData: StudyTimeCate[]
}

export const calcPercentage = (done: number, total: number) => {
  return Math.round(done / total * 100) + '%'
}