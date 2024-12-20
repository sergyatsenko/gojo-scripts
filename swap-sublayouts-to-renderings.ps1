$locale = 'en'
$data = @(
    [PSCustomObject]@{ OldId = "{6D3F9EDD-D4EE-4A56-AE46-6E6FA17278E4}"; Name = "Conditional Banner"; NewId = "{DC90131B-3F91-4205-A31D-681B7B03FD1E}" },
    [PSCustomObject]@{ OldId = "{E2BA2418-2F7B-44AD-8470-DB24460944A8}"; Name = "DistributorDispenserSectionNavigation"; NewId = "{6A0F6289-000A-4CBE-BEDD-5EF1D457BFEF}" },
    [PSCustomObject]@{ OldId = "{985D9153-8403-4189-8E4A-F1E7C81277AD}"; Name = "GlobalFooter"; NewId = "{779B1754-EF7A-47B6-93CA-FCC8D07D8DEA}" },
    [PSCustomObject]@{ OldId = "{453D639B-52EA-48CE-8247-E9D6FF2E13D9}"; Name = "HamburgerNavigation"; NewId = "{0ACC20FE-7862-4859-942D-3B758E9BEF5C}" },
    [PSCustomObject]@{ OldId = "{6678EB6D-D1B2-4A0A-9ACE-042FAA67086D}"; Name = "HomeBanner"; NewId = "{97D23401-13CE-4AB4-AFB6-3A086452E9E6}" },
    [PSCustomObject]@{ OldId = "{3720CC7E-EFF2-4DE2-B500-29F9F13BA972}"; Name = "Image Link List"; NewId = "{210E3C6C-F93E-4C0A-9CCA-B4D4543297A6}" },
    [PSCustomObject]@{ OldId = "{20D137FE-AEA9-4954-8394-7004EAFE1141}"; Name = "LanguageLabel"; NewId = "{13E9D73D-ECFE-4114-9EF8-FC91885D166E}" },
    [PSCustomObject]@{ OldId = "{963F1E12-D4A9-4984-A166-40530D4879FC}"; Name = "LanguageSelector"; NewId = "{C86BE79F-8826-4A82-8513-7E777DE8523E}" },
    [PSCustomObject]@{ OldId = "{AFB0E636-C830-4E52-A7F4-60BFFD9547BA}"; Name = "Local Footnote"; NewId = "{57F36A9C-DAEF-440F-961B-00D40024E8E8}" },
    [PSCustomObject]@{ OldId = "{CED4B77E-F771-4F11-A2ED-9E77F2B59183}"; Name = "Local Image Left Copy Right"; NewId = "{62DEA391-EC2D-49E3-9C8B-79957200452D}" },
    [PSCustomObject]@{ OldId = "{662D79FD-53EE-42C5-BBCB-7C6E3BB564D1}"; Name = "Local Intro Paragraph"; NewId = "{EB641835-41C6-468F-A671-80A4AC67BDEC}" },
    [PSCustomObject]@{ OldId = "{69561405-A859-4A44-B766-D6110CDEBF14}"; Name = "MarketBanner"; NewId = "{C3BC0CD6-AC77-4C22-A152-471CB2DEE627}" },
    [PSCustomObject]@{ OldId = "{0A467C94-C966-4311-8917-CE2165789ABB}"; Name = "MarketPage"; NewId = "{EB769D71-1E39-4FD2-87CA-CDA3E979D06B}" },
    [PSCustomObject]@{ OldId = "{56A58FB4-5FAA-416E-A9EF-52D5CE99BC22}"; Name = "Modal Button"; NewId = "{EFF5F959-9B7A-4D71-99C0-83F6018C5C86}" },
    [PSCustomObject]@{ OldId = "{9B80A999-BA40-47D5-985A-EA8B0DB8A5B9}"; Name = "ProductCatalogPage"; NewId = "{00BDE759-E18E-4FA8-B79A-629D44DF38EE}" },
    [PSCustomObject]@{ OldId = "{43A3EAAC-1455-4B17-A49D-C20EDBBFCD9A}"; Name = "ProductCategoryPage"; NewId = "{5761A49B-1E0F-44D7-84D5-C3DD57138C1B}" },
    [PSCustomObject]@{ OldId = "{13B8FDF0-1658-46C5-8C85-ED9E77ADC11A}"; Name = "ProductPage"; NewId = "{F4950989-0176-4F6E-8720-B680080B5C75}" },
    [PSCustomObject]@{ OldId = "{F6C978F9-CA3A-4AEB-9B42-D77CC552B35F}"; Name = "ProductSearchBox"; NewId = "{AEA4F93F-6EFD-4950-AA6D-2B77230489DB}" },
    [PSCustomObject]@{ OldId = "{B14EEEE0-C01E-41A6-9797-D1792BF040F2}"; Name = "SectionNavigation"; NewId = "{0A17A41F-2D0D-40E5-B07B-80F7AEB4030C}" },
    [PSCustomObject]@{ OldId = "{79895BE4-9F14-44D5-B5C6-8C8871B2441A}"; Name = "Shared Video Setup"; NewId = "{26B2B709-3D98-4CCF-92BF-0D83B2006A96}" },
    [PSCustomObject]@{ OldId = "{250F0805-8A3A-4459-AB5C-63AF045A7729}"; Name = "Stackable Snippet"; NewId = "{FCB614B6-92A2-4231-A6D7-8F6FB7996692}" }
)

foreach ($entry in $data) {
    $oldRenderingItem = Get-Item -Path "master" -ID $entry.OldId

    if ($null -ne $oldRenderingItem) {
        Write-Host "Found item: $($oldRenderingItem.Name) with ID: $($entry.OldId)"
        Write-Host "-------------------------------------------------------------------------------"
        $referrers = Get-ItemReferrer -Item $oldRenderingItem

        foreach ($referrerBase in $referrers) {
            $referrerInLocale = Get-Item -Path "master:" -ID $referrerBase.Id -Language $locale
            if ($referrerInLocale -ne $null -and $referrerInLocale.Versions.Count -gt 0) {
                $referrer = $referrerInLocale.Versions.GetLatestVersion()
                Write-Host "Processing Referrer: $($referrer.Name) with ID: $($referrer.ID)"
                $renderingsField = $referrer.Fields["__Renderings"].Value
                $finalRenderingsField = $referrer.Fields["__Final Renderings"].Value
    
                if ($renderingsField -like "*$($entry.OldId)*") {
                    $updatedRenderings = $renderingsField -replace [regex]::Escape($entry.OldId), $entry.NewId
                    Write-Host "renderingsField: " $renderingsField
                    Write-Host "updatedRenderings: " $updatedRenderings
                    $referrer.Editing.BeginEdit()
                    $referrer.Fields["__Renderings"].Value = $updatedRenderings
                    $referrer.Editing.EndEdit()
                    Write-Host "Updated Renderings field for Referrer: $($referrer.Name)"
                }
    
                if ($finalRenderingsField -like "*$($entry.OldId)*") {
                    $updatedFinalRenderings = $finalRenderingsField -replace [regex]::Escape($entry.OldId), $entry.NewId
                    Write-Host "finalRenderingsField: " $finalRenderingsField
                    Write-Host "updatedFinalRenderings: " $updatedFinalRenderings
                    $referrer.Editing.BeginEdit()
                    $referrer.Fields["__Final Renderings"].Value = $updatedFinalRenderings
                    $referrer.Editing.EndEdit()
                    Write-Host "Updated Final Renderings field for Referrer: $($referrer.Name)"
                }
            } else {
                Write-Host "Item does not exist or has no versions"
            }
        }
    } else {
        Write-Host "Not found item " $referrerBase.Id " with Language version " $locale
    }
}
