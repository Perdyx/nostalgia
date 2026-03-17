<script>
  import serverData from '$lib/server-data.json';
  
  export let ID;

  // Attempt to find the server
  const info = serverData.find(s => s.id === Number(ID));
  
  // If no data is found in the JSON, assume the data is still loading or the site is running locally
  const isLoading = !info || serverData.length === 0;
</script>

<div class="server-card">
  {#if isLoading}
    <div class="skeleton title"></div>
    <div class="skeleton text"></div>
    <div class="skeleton text short"></div>
  {:else}
    <h3>{info.name}</h3>
    <p><strong>Map:</strong> {info.map}</p>
    <p><strong>Connect:</strong> <code>{info.connect}</code></p>
    <small>Version: {info.version}</small>
    <small>Last updated: {info.last_update}</small>
  {/if}
</div>

<style>
  .server-card {
    border: 1px solid #333;
    padding: 1.5rem;
    border-radius: 12px;
    background: #1a1a1a;
    color: white;
    min-width: 250px;
  }

  .skeleton {
    background: linear-gradient(90deg, #222 25%, #333 50%, #222 75%);
    background-size: 200% 100%;
    animation: loading 1.5s infinite;
    border-radius: 4px;
    margin-bottom: 0.5rem;
  }

  .title { height: 24px; width: 70%; margin-bottom: 1rem; }
  .text { height: 16px; width: 90%; }
  .short { width: 40%; }

  @keyframes loading {
    0% { background-position: 200% 0; }
    100% { background-position: -200% 0; }
  }
</style>