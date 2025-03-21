/**
 * Http 请求工具，基于 axios 封装
 */
import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { authStore, HdUser } from './auth';
import { logger } from './logger'
import { promptAction, router } from '@kit.ArkUI';

export const baseURL = 'https://api-harmony-teach.itheima.net/hm/'

const instance = axios.create({
  baseURL,
  timeout: 100000
})

// 请求拦截器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  const user = authStore.getUser()
  if (user.token) {
    config.headers.Authorization = `Bearer ${user.token}`
  }
  return config
}, (err: AxiosError) => {
  logger.error('Req Error 2', JSON.stringify(err))
  if (err.response?.status === 401) {
    authStore.setUser({} as HdUser )
    router.pushUrl({
      url: 'pages/LoginPage'
    }, router.RouterMode.Single)
    promptAction.showToast({ message: '登录失效' })
  }
  return Promise.reject(err)
})

// 响应拦截器
instance.interceptors.response.use((res: AxiosResponse) => {
  if (res.data.code === 10000) {
    logger.debug('Req Success', JSON.stringify(res.data.data))
    return res.data.data
  }
  logger.error('Req Error', JSON.stringify(res.data))
  return Promise.reject(res.data)
}, (err: AxiosError) => {
  logger.error('Req Error', JSON.stringify(err))
  return Promise.reject(err)
})

class Http {
  // Get 请求可以省略第二个泛型，因为axios默认是any任何值可传
  request<ResponseData, RequestData = Object>(config: AxiosRequestConfig<RequestData>) {
    return instance<null, ResponseData, RequestData>(config)
  }
}

export const httpInstant = new Http()