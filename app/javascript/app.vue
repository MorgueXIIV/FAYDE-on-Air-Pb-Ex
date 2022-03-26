<template>
  <div id="app">
		<h1>FAYDE: Jamais Vue</h1>
		<p> An experimental Vue port of the FAYDE on Air. </p>
    <p>{{ message }}</p>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
