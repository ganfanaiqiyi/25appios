<template>
	<view>
		<u-status-bar></u-status-bar>
		<view style="height:260rpx;">
			<v-bannerAd :arrAd="bannerAd"></v-bannerAd>
		</view>
		<scroll-view show-scrollbar="false" class="col-12" :style="{height:scrollHeight+'px'}" :scroll-y="true">
			<view class="flex flex-row flex-wrap" style="width: 725rpx;margin-left: 25rpx;">
				<view style="width: 140rpx;" class="flex flex-column mb-2 align-center position-relative"
					@click="adClick(item)" v-for="(item,index) in iconAd" :key="index">
					<view class="position-relative" style="width: 120rpx;height: 120rpx;">
						<image class="position-absolute" src="@/static/images/covericon.jpg"
							style="width: 120rpx;height: 120rpx;top:0;left:0;border-radius: 20rpx;"></image>
						<v-image3 :image="item.image"></v-image3>
						<!-- 	<image class="position-absolute" src="@/static/images/iconmask.png"
							style="width: 120rpx;height: 120rpx;top:0;left:0;color:#f2f2f2;"></image>
						</image> -->
					</view>
					<text class="mt-1 font-weight-bold font-sm"
						style="color:#232323;height: 30rpx;line-height: 30rpx;width: 140rpx;text-align: center;">{{item.title}}</text>
				</view>
			</view>
		</scroll-view>

		<u-popup :show="popShow" bgColor="transparent" mode="center">
			<view class="flex flex-column align-center" style="width: 600rpx;height: 700rpx;">
				<image :src="popUrl" style="width: 550rpx;height: 550rpx;border-radius: 120rpx;"></image>
				<u-icon @click="closePop()" class="mt-5" name="close-circle" color="yellow" size="100rpx"></u-icon>
			</view>
		</u-popup>
	</view>
</template>

<script>
	import {
		mapState
	} from "vuex";
	import $utils from "../../libs/utils.js";
	import $maomi from "../../libs/maomi.js";
	export default {
		computed: {
			...mapState({
				iconAd: state => state.iconAd,
				floatAd: state => state.floatAd,
				bannerAd: state => state.bannerAd
			}),
			scrollHeight() {
				let systemInfo = uni.getSystemInfoSync();
				return systemInfo.windowHeight - systemInfo.statusBarHeight - uni.upx2px(260) - 5;
			}
		},
		data() {
			return {
				popShow: false,
				popUrl: "",
				popCount: 0,
			}
		},
		onLoad() {
			if (this.floatAd && this.floatAd.length > 0) {
				this.popShow = true;
				this.popUrl = this.floatAd[this.popCount].image;
			}
		},
		methods: {
			adClick(item) {
				$utils.goAd(item);
			},
			closePop() {
				this.popCount++;
				if (this.popCount >= this.floatAd.length) {
					this.popShow = false;
					return;
				}
				this.popUrl = this.floatAd[this.popCount].image;
			},
		}
	}
</script>

<style>

</style>