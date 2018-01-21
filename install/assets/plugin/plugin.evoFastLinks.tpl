/**
 * evoFastLinks
 *
 * Быстрые ссылки на ресурсы дерева в верхнее меню
 *
 * @author      webber (web-ber12@yandex.ru)
 * @category    plugin
 * @version     0.1
 * @license     http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @events OnManagerMenuPrerender
 * @internal    @properties &ids=Список id ресурсов через запятую;text;&tabname=Название пункта в верхнем меню;text;Быстрые ссылки
 * @internal    @installset base, sample
 * @internal    @modx_category Manager and Admin 
 */
$e =& $modx->event;
switch ($e->name ) {
    case 'OnManagerMenuPrerender':
        $list_id = explode(',', $ids);
        $list_id = array_map('trim', $list_id);
        if (count($list_id) > 0) {
            $menu['fast_links'] = array(
                'fast_links',
                'main',
                '<i class="fa fa-cog"></i> ' . $tabname,
                   'index.php?a=27&r=1&id=' . $list_id[0],
                   $tabname,
                '',
                '',
                'main',
                0,
                100,
                '',
               );
        }
        if (count($list_id) > 1) {
            $menu['fast_links'][3] = 'javascript:;';
            $menu['fast_links'][5] = ' return false;';
            $i = 1;
            $q = $modx->db->query("SELECT id,pagetitle FROM " . $modx->getFullTableName("site_content") . " WHERE id IN(" . implode(',', $list_id) . ")");
            $names = array();
            while ($row = $modx->db->getRow($q)) {
                $names[$row['id']] = $row['pagetitle'];
            }
            foreach ($list_id as $id) {
                $menu['fast_links' . $i] = array(
                    'fast_links' . $i,
                    'fast_links',
                    '<i class="fa fa-cog"></i> ' . $names[$id],
                       'index.php?a=27&r=1&id=' . $id,
                       $names[$id],
                    '',
                    '',
                    'main',
                    0,
                    $i,
                    '',
                   );
                $i++;
            }
        }
        $e->output(serialize($menu));
        break;
    default:
        break;
}