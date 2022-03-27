<template>
	<div id="app">
    <p>{{ message }}</p>
  </div>
</template>

<script lang="ts">
// import store from '@/store'
export default {
  data: function() {
    return {
      // sharedState: store.state,
      message: "Hello home"
    };
  },
  watch: {
    onCreated: function(response) {
      this.items = response.data;
    }
  },
  methods: {
    //Add the button to your template: <button @click="onClick">click this</button>
    onClick: function() {
      console.log("clicked");
    }
  },
  computed: {}
  // props: {},
  // components: {},
  // mixins: [],
  // directives: {},
  // filters: {},
  // asyncComputed: {},
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
