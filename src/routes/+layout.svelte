<script>
    import './layout.css';
    import favicon from '$lib/assets/favicon.svg';
    import * as NavigationMenu from "$lib/components/ui/navigation-menu/index.js";
    import { Button } from "$lib/components/ui/button/index.js";
    import { Separator } from "$lib/components/ui/separator/";
    import { buttonVariants } from "$lib/components/ui/button/";
    import { cn } from "$lib/utils.js";
    
    import { ModeWatcher } from "mode-watcher";
    import { toggleMode } from "mode-watcher";
    
    import { Copyright, Eclipse, Minimize, MoonIcon, Swords } from "@lucide/svelte";
    
    let { children } = $props();
    
    const rows = Array(60).fill(0);
    const cols = Array(120).fill(0);
</script>

<svelte:head><link rel="icon" href={favicon} /></svelte:head>
<ModeWatcher />

<NavigationMenu.Root class="max-w-full w-full justify-start px-8 py-4 sticky top-0 z-50 bg-background border-b">
    <NavigationMenu.List class="max-w-full w-full flex items-center">
        <NavigationMenu.Item>
            <NavigationMenu.Link class="font-medium text-[16px]">LOGO</NavigationMenu.Link>
        </NavigationMenu.Item>
    </NavigationMenu.List>
</NavigationMenu.Root>

<div class="relative min-h-screen w-full overflow-hidden bg-background">
    <div class="absolute left-0 top-0 flex h-[200vh] w-[200vw] -ml-[50vw] -mt-[50vh] rotate-12 flex-col justify-center gap-8 pointer-events-none">
        {#each rows as _, rowIndex}
        <div class="flex w-full justify-center gap-8">
            {#each cols as _, colIndex}
            <div class="text-foreground/20">
                {#if (rowIndex + colIndex) % 2 === 0}
                <Swords size={24} strokeWidth={1.5} />
                {:else}
                <Minimize size={24} strokeWidth={1.5} />
                {/if}
            </div>
            {/each}
        </div>
        {/each}
    </div>
    
    <div class="relative z-10 flex flex-col gap-8 w-full max-w-[900px] mx-auto py-12 px-4">
        {@render children?.()}
    </div>
</div>

<footer class="w-full border-t bg-background py-6 text-center">
    <div class="container mx-auto flex flex-col items-center gap-2">
        <div class="flex items-center gap-1 text-sm text-muted-foreground">
            <span>
                Built with 
                <a href="https://www.shadcn-svelte.com/" target="_blank" rel="noreferrer" class="font-medium underline underline-offset-4">shadcn-svelte</a>.
            </span>
            <!-- <Separator orientation="vertical" class="h-6" /> -->
            <span>
                Code licensed under
                <a href="https://github.com/Perdyx/nostalgia/blob/main/LICENSE" target="_blank" rel="noreferrer" class="font-medium underline underline-offset-4">MIT License</a>.
            </span>
        </div>

        <div class="flex items-center gap-1.5 text-xs text-muted-foreground/60">
            <Copyright class="size-3" />
            <span>{new Date().getFullYear()}</span>
        </div>
    </div>
</footer>