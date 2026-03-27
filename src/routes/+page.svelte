<script lang="ts">
    import GameCard from "../lib/components/GameCard.svelte";

    const unturnedServers = [
        { id: "10997380" },
        { id: "10997383" },
        { id: "10997381" },
        { id: "10997382", offlineReason: "TEST SERVER - OFFLINE" }
    ];

    const groundBranchServers = [
        { id: "11181191" }
    ];
</script>

<div class="grid gap-6">
  <GameCard 
    title="Unturned" 
    servers={unturnedServers} 
    startIndex={0} 
  />

  <GameCard 
    title="Ground Branch" 
    servers={groundBranchServers} 
    startIndex={unturnedServers.length} 
  />
</div>