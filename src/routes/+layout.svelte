<script>
    // Styles & Assets
    import "./layout.css";
    import favicon from "$lib/assets/favicon.svg";
    import hero from "$lib/assets/hero.jpg"

    // Shadcn UI Components
    import * as NavigationMenu from "$lib/components/ui/navigation-menu/index.js";
    import { Button, buttonVariants } from "$lib/components/ui/button/index.js";
    import { Separator } from "$lib/components/ui/separator/index.js";

    // Utilities & Theme Management
    import { cn } from "$lib/utils.js";
    import { ModeWatcher, toggleMode } from "mode-watcher";

    // Icons
    import { 
        Copyright, 
        Eclipse, 
        Minimize, 
        MoonIcon, 
        Swords 
    } from "@lucide/svelte";
    
    let { children } = $props();
    
    // Configure background icon grid
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

<section class="relative w-full h-[600px] overflow-hidden">
  <img src={hero} alt="Screenshot from Ground Branch (2025)" class="absolute inset-0 w-full h-full object-cover object-center" />
  <div class="absolute inset-0 bg-gradient-to-r from-black via-black/40 to-transparent"></div>
  
  <div class="relative z-10 container mx-auto h-full flex flex-col justify-center px-6 lg:px-12">
    <div class="max-w-2xl space-y-6">
      <h1 class="text-4xl md:text-5xl font-extrabold tracking-tight text-foreground">
        Title
      </h1>
      
      <p class="text-lg md:text-xl text-foreground-muted leading-relaxed">
        The paragraph from the server browser and stuff. Some other text that I don't have right now.
      </p>

      <div class="pt-4">
        <Button size="lg" class="px-8 py-6 text-lg transition-transform" href="https://discord.gg/">
          Join the Discord!
        </Button>
      </div>
    </div>
  </div>
</section>

<div class="relative min-h-screen w-full overflow-hidden bg-background">
    <div class="absolute left-0 top-0 flex h-[200vh] w-[200vw] -ml-[50vw] -mt-[50vh] rotate-12 flex-col justify-center gap-8 pointer-events-none">
        {#each rows as _, rowIndex}
        <div class="flex w-full justify-center gap-8">
            {#each cols as _, colIndex}
            <div class="text-foreground/20">
                {#if (rowIndex + colIndex) % 2 === 0}
                <Swords size={24} strokeWidth={2} />
                {:else}
                <Minimize size={24} strokeWidth={2} />
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