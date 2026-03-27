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
        GamepadDirectional, 
        MoonIcon, 
        Flame 
    } from "@lucide/svelte";
    
    let { children } = $props();
    
    // Configure background icon grid
    const rows = Array(60).fill(0);
    const cols = Array(120).fill(0);
</script>

<svelte:head><link rel="icon" href={favicon} /></svelte:head>

<NavigationMenu.Root class="max-w-full w-full justify-start px-8 py-4 sticky top-0 z-50 bg-background border-b">
    <NavigationMenu.List class="max-w-full w-full flex items-center">
        <NavigationMenu.Item>
            <NavigationMenu.Link class="font-medium text-[16px]">LOGO</NavigationMenu.Link>
        </NavigationMenu.Item>
    </NavigationMenu.List>
</NavigationMenu.Root>

<div class="relative flex flex-col items-center">
    <div class="z-10 w-full" style:mask-image="linear-gradient(to bottom, black calc(100% - 300px), transparent 100%)" style:-webkit-mask-image="linear-gradient(to bottom, black calc(100% - 300px), transparent 100%)">
        <section class="relative w-full h-175 overflow-hidden">
            <img src={hero} alt="Screenshot from Ground Branch (2025)" class="absolute inset-0 w-full h-full object-cover object-center" />
            <div class="absolute inset-0 bg-linear-to-r from-black to-transparent"></div>
            
            <div class="relative z-10 container mx-auto h-full flex flex-col justify-center px-6 lg:px-12">
                <div class="max-w-2xl space-y-6">
                    <h1 class="text-5xl font-extrabold tracking-wide text-foreground">
                        Nostalgia Network
                    </h1>
                    
                    <p class="text-lg text-foreground/69 leading-relaxed">
                        Welcome to the Nostalgia game network! All of our servers are privately owned, facilitated, and maintained and are backed up nightly at midnight (PST). Please join our Discord server to read the rules, get notified about changes, and join the growing community!
                    </p>

                    <div class="pt-4">
                        <Button size="lg" class="px-8 py-6 text-lg transition-transform" href="https://discord.gg/SFwzAnRjvv">
                            Join the Discord!
                        </Button>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <div class="w-full" style:margin-top="-50px" style:mask-image="linear-gradient(to top, black calc(100% - 150px), transparent 100%)" style:-webkit-mask-image="linear-gradient(to top, black calc(100% - 150px), transparent 100%)">
        <div class="relative min-h-screen w-full overflow-hidden bg-background">
            <div class="absolute left-0 top-0 flex h-[200vh] w-[200vw] -ml-[50vw] -mt-[50vh] rotate-12 flex-col justify-center gap-8 pointer-events-none">
                {#each rows as _, rowIndex}
                <div class="flex w-full justify-center gap-8">
                    {#each cols as _, colIndex}
                    <div class="text-foreground/10">
                        {#if (rowIndex + colIndex) % 2 === 0}
                            <Flame size={32} strokeWidth={1} />
                        {:else}
                            <GamepadDirectional size={32} strokeWidth={1} />
                        {/if}
                    </div>
                    {/each}
                </div>
                {/each}
            </div>

            <div class="relative z-10 flex flex-col gap-8 w-full max-w-400 mx-auto py-48 px-4">
                {@render children?.()}
            </div>
        </div>
    </div>
</div>

<footer class="w-full border-t bg-background py-8 text-center">
    <div class="container mx-auto flex flex-col items-center gap-2">
        <div class="flex items-center gap-1 text-sm text-muted-foreground">
            <span>
                Built with 
                <a href="https://www.shadcn-svelte.com/" target="_blank" rel="noreferrer" class="font-medium underline underline-offset-4">shadcn-svelte</a>.
            </span>
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