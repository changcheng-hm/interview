import { HcSkeleton, HcSkeletonItem, httpInstant, logger, LOGIN_EVENT } from '@cc_interview/basic';
import { SortType } from '../models/QuestionItemModel';
import { QuestionType } from '../models/QuestionTypeModel';
import { FilterButton } from './FilterButton';
import { QuestionListComp } from './QuestionListComp';
import { emitter } from '@kit.BasicServicesKit';
import { AxiosError } from '@ohos/axios';

@Extend(Text)
function textTitle() {
  .fontSize(14)
  .fontWeight(500)
  .fontColor($r('app.color.black'))
  .width('100%')
  .margin({ top: 20 })
}

@Component
export struct HomeCategoryComp {
  @State filterDataIndex: number = 0
  @State questionTypeList: QuestionType[] = []
  @State activeIndex: number = 0

  @State isShow: boolean = false

  @State filterDataSort: SortType = SortType.Default

  @State sort: SortType = SortType.Default

  @State loading: boolean = false

  aboutToAppear(): void {
    this.getQuestionTypeList()
    // 触发 LOGIN_EVENT 更新数据
    emitter.on(LOGIN_EVENT, () => {
      this.getQuestionTypeList()
    })
  }

  async getQuestionTypeList () {
    this.loading = true
    try {
      const res = await httpInstant.request<QuestionType[], null>({ url: 'question/type' })
      this.questionTypeList = res
      this.loading = false
    } catch (err) {
      logger.error((err as AxiosError).message)
    }
  }

  @Builder
  SkeletonBuilder() {
    HcSkeleton() {
      Column() {
        Row({ space: 16 }) {
          HcSkeletonItem({ widthValue: 60 })
          HcSkeletonItem({ widthValue: 100 })
          HcSkeletonItem({ widthValue: 80 })
          HcSkeletonItem({ widthValue: 40 })
        }
        .height(44)
        .width('100%')

        ForEach([1, 2, 3, 4, 5, 6], () => {
          Column({ space: 10 }) {
            HcSkeletonItem({ widthValue: '90%' })
            HcSkeletonItem({ widthValue: '45%' })
          }
          .height(80)
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
        })
      }
      .padding({ left: 16, right: 16 })
    }
  }

  @Builder
  FilterSheetBuilder() {
    Column() {
      Row() {
        Text('重置')
          .fontSize(16)
          .fontWeight(500)
          .fontColor($r('app.color.common_gray_03'))
          .onClick(() => {
            this.filterDataIndex = 0
            this.filterDataSort = SortType.Default
          })
        Text('筛选题目')
          .layoutWeight(1)
          .fontSize(18)
          .fontWeight(500)
          .fontColor($r('app.color.black'))
          .textAlign(TextAlign.Center)
        Text('完成')
          .fontWeight(500)
          .fontSize(16)
          .fontColor($r('app.color.common_main_color'))
          .onClick(() => {
            this.isShow = false
            this.activeIndex = this.filterDataIndex
            this.sort = this.filterDataSort
          })
      }
      .margin({ bottom: 4, top: 4 })

      Text('题目排序')
        .textTitle()
      // 排序方式
      Flex({ wrap: FlexWrap.Wrap }) {
        FilterButton({ text: '默认', selected: this.filterDataSort === SortType.Default })
          .onClick(() => {
            this.filterDataSort = SortType.Default
          })
        FilterButton({
          text: '浏览量',
          isSort: true,
          selected: this.filterDataSort === SortType.ViewLow ||
            this.filterDataSort === SortType.ViewHigh,
          sort: this.filterDataSort
        })
          .onClick(() => {
            if (this.filterDataSort === SortType.ViewLow || this.filterDataSort === SortType.ViewHigh) {
              this.filterDataSort = this.filterDataSort === SortType.ViewLow ? SortType.ViewHigh : SortType.ViewLow
            } else {
              this.filterDataSort = SortType.ViewLow
            }
          })
        FilterButton({
          text: '难度',
          isSort: true,
          selected: this.filterDataSort === SortType.DifficultyLow ||
            this.filterDataSort === SortType.DifficultyHigh,
          sort: this.filterDataSort
        })
          .onClick(() => {
            if (this.filterDataSort === SortType.DifficultyLow || this.filterDataSort === SortType.DifficultyHigh) {
              this.filterDataSort =
                this.filterDataSort === SortType.DifficultyLow ? SortType.DifficultyHigh : SortType.DifficultyLow
            } else {
              this.filterDataSort = SortType.DifficultyLow
            }
          })
        FilterButton({ text: '推荐', selected: this.filterDataSort === SortType.Commend })
          .onClick(() => {
            this.filterDataSort = SortType.Commend
          })
      }

      Text('选择分类')
        .textTitle()
      // 选择分类
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.questionTypeList, (item: QuestionType, i) => {
          FilterButton({
            text: item.name,
            isNew: item.displayNewestFlag === 1,
            selected: this.filterDataIndex === i
          })
            .onClick(() => {
              this.filterDataIndex = i
            })
        })
      }
    }
    .padding(16)
    .backgroundColor($r('app.color.white'))
    .height('100%')
  }

  @Builder
  TabBarBuilder(item: QuestionType, i: number) {
    Row() {
      Stack({ alignContent: Alignment.Bottom }){
        Text(item.name)
          .fontSize(15)
          .fontColor(this.activeIndex === i ? $r('app.color.black') : $r('app.color.common_gray_01'))
          .height(44)
        Text()
          .width(this.activeIndex === i ? 20 : 0)
          .height(2)
          .backgroundColor($r('app.color.black'))
          .animation({ duration: this.activeIndex === i ? 300 : 0 })
      }
      if (item.displayNewestFlag === 1) {
        Image($r('app.media.ic_home_new'))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .margin({ left: 4 })
      }
    }
    .padding({ left: 16, right: this.questionTypeList.length === i + 1 ? 16 : 0 })
  }

  build() {
    if (this.loading) {
      this.SkeletonBuilder()
    } else {
      Stack({ alignContent: Alignment.TopEnd }) {
        Tabs({ index: this.activeIndex }) {
          ForEach(this.questionTypeList, (item: QuestionType, i) => {
            TabContent() {
              QuestionListComp({
                typeId: item.id,
                sort: this.sort,
                activeIndex: this.activeIndex,
                index: i
              })
            }
            .tabBar(this.TabBarBuilder(item, i))
          })
        }
        .onTabBarClick((i) => {
          this.activeIndex = i
        })
        .barMode(BarMode.Scrollable)
        .barHeight(44)
        .scrollable(false)
        .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_border') })

        Row() {
          Image($r('app.media.ic_home_filter'))
            .width(24)
            .aspectRatio(1)
        }
        .width(56)
        .height(44)
        .justifyContent(FlexAlign.Center)
        .linearGradient({ angle: 90, colors: [['#00FFFFFF', 0], ['#FFFFFF', 0.285]] })
        .bindSheet($$this.isShow, this.FilterSheetBuilder(), {
          showClose: false,
          height: 400
        })
        .onClick(() => {
          this.isShow = true
          this.filterDataIndex = this.activeIndex
        })
      }
    }
  }
}