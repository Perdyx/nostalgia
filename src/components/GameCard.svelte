<script>
    import * as Card from "$lib/components/ui/card";
    import { Server } from "@lucide/svelte";
    import ServerCard from "./ServerCard.svelte";
    import ServerCardOverlay from "./ServerCardOverlay.svelte";
    
    export let title = "";
    export let servers = []; // Object format: { id: string, offlineReason?: string }
    export let startIndex = 0;
    
    // Automatically calculate the count based on the array length
    $: serverCount = servers.length;
</script>

<Card.Root class="overflow-hidden border-border bg-card shadow-sm">
    <Card.Header>
        <div class="flex flex-col items-start text-left">
            <Card.Title class="text-xl font-bold tracking-tight text-card-foreground">
                {title}
            </Card.Title>
            <div class="flex items-center gap-2 mt-1">
                <Server class="w-4 h-4 text-primary" />
                <span class="text-sm text-muted-foreground font-medium">
                    Servers: {serverCount}
                </span>
            </div>
        </div>
    </Card.Header>
    
    <Card.Content class="flex flex-col gap-4">
        {#each servers as server, i}
            {#if server.offlineReason}
                <ServerCardOverlay reason={server.offlineReason}>
                    <ServerCard ID={server.id} index={startIndex + i} />
                </ServerCardOverlay>
            {:else}
                <ServerCard ID={server.id} index={startIndex + i} />
            {/if}
        {/each}
    </Card.Content>
</Card.Root>