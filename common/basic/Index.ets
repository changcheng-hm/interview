export { logger } from './src/main/ets/utils/logger'
export { themeUtils } from './src/main/ets/utils/themeUtils'
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
export { formatTime } from './src/main/ets/utils/TimeUtils'

export const LOGIN_EVENT = 'LOGIN_EVENT'

export interface QuestionOptParams {
  id: string
  /* 0 试题  2 面经 */
  type: 0 | 1
  /* 1 点赞  2 收藏 */
  optType: 1 | 2
}