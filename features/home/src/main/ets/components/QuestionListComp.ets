import { PageData, QuestionItem, QuestionListParams, QuestionPageParams, SortType } from '../models/QuestionItemModel';
import { QuestionItemComp } from './QuestionItemComp';
import { promptAction } from '@kit.ArkUI';
import { authStore, httpInstant } from '@cc_interview/basic';

@Component
export struct QuestionListComp {
  @State list: QuestionItem[] = []
  // 控制刷新的状态
  @State isRefreshing: boolean = false
  // 是否加载完成
  @State isFinished: boolean = false
  // 正在加载中...
  @State isLoading: boolean = false

  @Prop typeId: number

  @Prop @Watch('onChangeSort') sort: SortType = SortType.Default
  @Prop activeIndex: number
  @Prop index: number

  @State page: number = 1

  @Prop keyword: string = ''

  @Builder
  LoadMoreBuilder() {
    ListItem() {
      // 加载完成
      if (this.isFinished) {
        Row() {
          Text('没有更多了~')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_03'))
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
      // 没有加载完成且正在加载中
      else if (this.isLoading) {
        Row({ space: 4 }) {
          LoadingProgress()
            .width(20)
          Text('正在加载...')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_03'))
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
    }
    .height(80)
  }

  getQuestionList(): Promise<PageData<QuestionItem>> {
    return httpInstant.request<PageData<QuestionItem>>({
      url: 'question/list',
      params: {
        type: this.typeId,
        keyword: this.keyword,
        questionBankType: 10,
        sort: this.sort,
        page: this.page,
        pageSize: 10
      } as QuestionListParams
    })
  }

  // 加载逻辑
  async onLoad() {
    const res = await this.getQuestionList()
    this.list.push(...res.rows)
    this.isLoading = false
    if (this.page >= res.pageTotal) {
      this.isFinished = true
    } else {
      this.page++
    }
  }

  async onRefresh() {
    this.page = 1
    const res = await this.getQuestionList()
    this.list = res.rows
    this.isRefreshing = false
    if (this.page >= res.pageTotal) {
      this.isFinished = true
    } else {
      this.isFinished = false
      this.page++
    }
    promptAction.showToast({ message: '更新成功' })
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      List() {
        ForEach(this.list, (item: QuestionItem) => {
          ListItem() {
            QuestionItemComp({
              item: item
            })
            .onClick(() => {
              authStore.checkAuth({
                url: 'pages/QuestionPage',
                params: {
                  item,
                  list: this.list
                } as QuestionPageParams
              })
            })
          }
        })
        this.LoadMoreBuilder()
      }
      .onReachEnd(() => {
        if (this.isLoading || this.isFinished || this.isRefreshing ) {
          return
        }
        this.isLoading = true
        this.onLoad()
      })
      .divider({
        strokeWidth: 0.5,
        color: $r('app.color.common_gray_border'),
        startMargin: 16,
        endMargin: 16
      })
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
    }.onRefreshing(() => {
      this.onRefresh()
    })
  }

  onChangeSort() {
    if (this.activeIndex === this.index) {
      this.isRefreshing = true
    }
  }
}