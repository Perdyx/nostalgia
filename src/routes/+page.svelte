<script lang="ts">
    import * as Card from "$lib/components/ui/card/index.js";
    import { CloudFog } from "@lucide/svelte";
    import ServerCard from "../components/ServerCard.svelte";
    import ServerCardOverlay from "../components/ServerCardOverlay.svelte";
</script>

<div class="flex flex-col gap-8 w-full max-w-[900px] mx-auto py-12">
    <Card.Root class="overflow-hidden border-border bg-card shadow-sm">
        <Card.Header> 
            <div class="flex flex-col items-start text-left">
                <Card.Title class="text-xl font-bold tracking-tight text-card-foreground">
                    Unturned
                </Card.Title>
                <div class="flex items-center gap-2 mt-1">
                    <CloudFog class="w-4 h-4 text-orange-500" />
                    <span class="text-sm text-muted-foreground font-medium">
                        Servers: 4
                    </span>
                </div>
            </div>
        </Card.Header>
        
        <Card.Content class="flex flex-col gap-4">
            <ServerCard ID="10997380" index={0} />
            <ServerCard ID="10997383" index={1} />
            <ServerCard ID="10997381" index={2} />

            <ServerCardOverlay reason="TEST SERVER - OFFLINE">
                <ServerCard ID="10997382" index={3} />
            </ServerCardOverlay>
        </Card.Content>
    </Card.Root>

    <Card.Root class="overflow-hidden border-border bg-card shadow-sm">
        <Card.Header>
            <div class="flex flex-col items-start text-left">
                <Card.Title class="text-xl font-bold tracking-tight text-card-foreground">
                    Ground Branch
                </Card.Title>
                <div class="flex items-center gap-2 mt-1">
                    <CloudFog class="w-4 h-4 text-orange-500" />
                    <span class="text-sm text-muted-foreground font-medium">
                        Servers: 1
                    </span>
                </div>
            </div>
        </Card.Header>
        
        <Card.Content class="flex flex-col gap-4">
            <ServerCard ID="11181191" index={4} />
        </Card.Content>
    </Card.Root>
</div>