import consumer from "./consumer"

export default function channelExisted(channel, label = null, id = null,) {

  let channel_index;

  if (label && id) {
    channel_index = consumer.subscriptions['subscriptions'].findIndex((el) => el.identifier === '{\"channel\":\"' + channel + '\",\"' + label + '\":\"' + id +'\"}')
  } else {
    channel_index = consumer.subscriptions['subscriptions'].findIndex((el) => el.identifier === '{\"channel\":\"' + channel + '\"}')
  }
  return channel_index > -1
}