<template>
	<view>
		<v-ypList :list="gameAd" ></v-ypList>
	</view>
</template>

<script>
	import {
		mapState
	} from "vuex";
	import $utils from "../../libs/utils.js";
	export default {
		computed: {
			...mapState({
				gameAd: state => state.gameAd
			})
		},
		data() {
			return {
				
			}
		},
		onLoad() {
			console.warn(this.gameAd)
		},
		methods: {
			
		}
	}
</script>

<style>

</style>
