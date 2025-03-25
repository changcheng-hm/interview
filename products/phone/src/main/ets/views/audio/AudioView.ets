import { audioDB, authStore, HcNavBar, InputDialog, InterviewAudioItem } from '@cc_interview/basic';
import { AudioItemComp } from '../../components/AudioItemComp';
import { AudioRecordComp } from '../../components/AudioRecordComp';
import { AudioPlayer } from './AudioPlayer';

@Extend(Text)
function actionButton(color: ResourceColor) {
  .width(80)
  .aspectRatio(1)
  .backgroundColor(color)
  .textAlign(TextAlign.Center)
  .fontColor($r('app.color.white'))
}

@Preview
@Component
export struct AudioView {
  @State isShow: boolean = false
  @State list: InterviewAudioItem[] = []
  @State currentItem: InterviewAudioItem = {} as InterviewAudioItem

  @Builder
  PlayerBuilder () {
    Column(){
      AudioPlayer({ item: this.currentItem })
    }
  }

  dialog = new CustomDialogController({
    builder: InputDialog({
      name: this.currentItem.name,
      onSubmit: async (name) => {
        const item = this.currentItem
        item.name = name
        await audioDB.update(item)
        await this.getList()
        this.dialog.close()
      }
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  async aboutToAppear() {
    await audioDB.initStore()
    await this.getList()
  }

  async getList() {
    const user = authStore.getUser()
    const rows = await audioDB.query(user.id)
    this.list = rows
  }

  @Builder
  ListItemSwiperBuilder(item: InterviewAudioItem) {
    Row() {
      Text('编辑')
        .actionButton($r('app.color.common_blue'))
        .onClick(() => {
          this.currentItem = item
          this.dialog.open()
        })
      Text('删除')
        .actionButton('#FF0033')
        .onClick(async () => {
          await audioDB.delete(item.id!)
          this.getList()
        })
    }
    .height('100%')
  }

  build() {
    Column() {
      HcNavBar({ title: '面试录音', showRightIcon: false })
      Column() {
        List() {
          ForEach(this.list, (item: InterviewAudioItem) => {
            ListItem() {
              AudioItemComp({
                item: item
              })
            }
            .swipeAction({
              end: this.ListItemSwiperBuilder(item)
            })
            .onClick(() => {
              this.currentItem = item
              this.isShow = true
            })
          })
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .layoutWeight(1)

      AudioRecordComp({
        onRecordEnd: async (item: InterviewAudioItem) => {
          await audioDB.insert(item)
          // TODO 更新列表
          await this.getList()
        }
      })
    }
    .width('100%')
    .height('100%')
    .bindContentCover($$this.isShow, this.PlayerBuilder())
  }
}